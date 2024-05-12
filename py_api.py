#!/usr/bin/python
import sys, time, clingo
from clingox.program import Program, ProgramObserver, Remapping, Rule

def rewrite_rule(rule, max_atom):
    body = [(l if l > 0 else max_atom + abs(l)) for l in rule.body]
    return Rule(rule.choice, rule.head, body)

class ClingoApp(clingo.application.Application):

    def main(self, ctl, files):
        ctl2 = clingo.Control()
        ctl2.load("examples/bt_0100.asp")
        prg = Program()
        ctl2.register_observer(ProgramObserver(prg))
        ctl2.ground()
        start = time.time()
        max_atom = max(max(max(rule.head, default=0), max((abs(l) for l in rule.body), default=0)) for rule in prg.rules)
        prg.rules = [rewrite_rule(rule, max_atom) for rule in prg.rules]
        new_output_atoms = dict()
        for atom, symbol in prg.output_atoms.items():
            new_output_atoms[max_atom+atom] = clingo.Function("not_" + symbol.name, symbol.arguments, symbol.positive)
        with ctl.backend() as backend:
            mapping = Remapping(backend, prg.output_atoms, prg.facts)
            prg.add_to_backend(backend, mapping)
        ctl.ground()
        end = time.time()
        total = elapsed = end - start
        print("\nGrounding (facts): {0:.3f} seconds".format(elapsed))
        # ctl.solve()

clingo.application.clingo_main(ClingoApp())