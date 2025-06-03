#
# Minimal PyROOT script to test software installation.
# Command line usage:
#
#   % cd Desktop/lae
#   % python -i sample/ROOT/histo.py
#
#
# Luca Pacher - pacher@to.infn.it
# Spring 2020
#


## load ROOT components into Python 
import ROOT

Ntrials = 10000

histo = ROOT.TH1F("histo","MC example",100,-5,5)

## keep track of Poisson errors on bin entries
histo.Sumw2()

## generate normally-distributed random values
histo.FillRandom("gaus",Ntrials)

## normalize the distribution to unit area
histo.Scale(1.0/histo.GetEntries())

## draw the histogram with error bars
histo.Draw("E")

## gaussian fit
histo.Fit("gaus")

## display fit results
ROOT.gStyle.SetOptFit(1)

## create new ROOT file
fout = ROOT.TFile("histo.root","RECREATE")

## save the histogram to ROOT file
histo.Write()

## close the file handler
fout.Close()
