#!/usr/bin/python
import sys, time, clingo


class ClingoApp(clingo.application.Application):

    def main(self, ctl, files):
        ctl.load("examples/bt_0100.asp")
        start = time.time()
        ctl.ground()
        end = time.time()
        total = elapsed = end - start
        print("\nGrounding: {0:.3f} seconds".format(elapsed))
        # ctl.solve()

clingo.application.clingo_main(ClingoApp())