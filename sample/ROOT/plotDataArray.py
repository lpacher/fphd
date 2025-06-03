
####################################################################
##
## Simple PyROOT script to plot and fit a set of y-data vs. x-data
## experimental values stored into standard Python lists.
##
## Execute the script at the command prompt with:
##
##    % python -i plotDataArray.py
##
## Luca Pacher - pacher@to.infn.it
## Spring 2016
##
####################################################################

"""
**IMPORTANT NOTE**

The ROOT TGraph(Npt,xData,yData) constructor uses C/C++ arrays for
x-values and y-values. This remains true also when using TGraph
from Python.

As a result you cannot specify xData and yData as simple Python
lists

   xData = [x1,x2, ... ]
   yData = [y1,y2, ... ]

and use these lists into the TGraph constructor. For this purpose
you need to create true C/C++ arrays with the numpy.array() method
from the NumPy package as follows:

   import numpy

   xData = numpy.array( [x1,x2, ... ] )
   yData = numpy.array( [y1,y2, ... ] )


Indeed, another possibility is to use the TGraph(Npt) constructor
and then "fill" the graph with a for-loop. With this solution you
can also use simple Python lists.
"""


## load ROOT components into Python 
import ROOT

## **OPTIONAL: load NumPy package and use numpy.array() to build C-style arrays
#import numpy


## measured data stored into NumPy arrays
#xData = numpy.array([283.   , 567.   , 849.   , 1133.   , 1415.   ])
#yData = numpy.array([3.35e6 , 1.95e6 , 1.42e6 , 1.088e6 , 863.8e3 ])


## measured data stored into simple Python lists
xData = [283.   , 567.   , 849.   , 1133.   , 1415.   ]
yData = [3.35e6 , 1.95e6 , 1.42e6 , 1.088e6 , 863.8e3 ]


## number of (x,y) experimental values
#Npt = len(xData)
Npt = 5


## create TGraph objects
gr1 = ROOT.TGraph(Npt)
gr2 = ROOT.TGraph(Npt)


## fill TGraph plots with points
for k in range(Npt):

    gr1.SetPoint(k,(xData[k]+1),yData[k])
    gr2.SetPoint(k,1/(xData[k]+1),yData[k])


## set marker size and style
gr1.SetMarkerStyle(21) ; gr2.SetMarkerStyle(22)
gr1.SetMarkerSize(0.8) ; gr2.SetMarkerStyle(21)

## set line width and style
#gr1.SetLineWidth(1)
#gr1.SetLineStyle(1)

## plot title
gr1.SetTitle("frequency vs (N+1)") ; gr2.SetTitle("frequency vs 1/(N+1)")

## x-axis setup
#gr1.GetXaxis().SetTitle("x-axis [unit]")
#gr1.GetXaxis().CenterTitle()
#gr1.GetXaxis().SetRangeUser(...)
#gr1.GetXaxis().SetNdivisions(...)
#gr1.GetXaxis().SetTickLength(...)
#gr1.GetXaxis().SetLabelOffset(...)
#gr1.GetXaxis().SetLabelSize(...)  
#gr1.GetXaxis().SetLabelFont(...)
#gr1.GetXaxis().SetTitleOffset(...)
#gr1.GetXaxis().SetTitleSize(...)
#gr1.GetXaxis().SetTitleFont(...)

## y-axis setup
#gr1.GetYaxis().SetTitle("y-axis [unit]")
#gr1.GetYaxis().CenterTitle()
#gr1.GetYaxis().SetRangeUser(...)
#gr1.GetYaxis().SetNdivisions(...)
#gr1.GetYaxis().SetTickLength(...)
#gr1.GetYaxis().SetLabelOffset(...)
#gr1.GetYaxis().SetLabelSize(...)
#gr1.GetYaxis().SetLabelFont(...)
#gr1.GetYaxis().SetTitleOffset(...)
#gr1.GetYaxis().SetTitleSize(...)
#gr1.GetYaxis().SetTitleFont(...)

#gr1.Draw("ALP")

c1 = ROOT.TCanvas("c1","Ring-oscillator frequency study",800,400)

c1.Divide(2,1)

c1.cd(1)
gr1.Draw("ALP")

c1.cd(2)
gr2.Draw("ALP")

