#!/usr/bin/python
import sys, time, clingo


class ClingoApp(clingo.application.Application):

    def main(self, ctl, files):
        ctl.load("examples/bt_0100.facts")
        start = time.time()
        ctl.ground()
        end = time.time()
        total = elapsed = end - start
        print("\nGrounding (facts): {0:.3f} seconds".format(elapsed))
        ctl.load("meta2.lp")
        start = time.time()
        ctl.ground()
        end = time.time()
        elapsed = end - start
        total += elapsed
        print("Grounding (rules): {0:.3f} seconds".format(elapsed))
        print("Grounding (total): {0:.3f} seconds\n".format(total))
        # ctl.solve()

clingo.application.clingo_main(ClingoApp())