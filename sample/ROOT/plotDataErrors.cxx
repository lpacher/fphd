//
// Simple un-named ROOT script to plot and fit a set of x-data vs. y-data including
// error bars stored on an external plain text file.
//
// Execute the script at the ROOT command prompt with:
//
//    root[] .x plotDataErrors.cxx
//
// Luca Pacher - pacher@to.infn.it
// Spring 2016
//


{
   gROOT->Reset() ;

   //TGraphErrors  gr("/path/to/fileName.dat") ;                    // similar syntax as for a TGraph object
   //TGraphErrors  *gr = new TGraph("/path/to/fileName.dat") ;

   TGraphErrors  *gr = new TGraphErrors("dataErrors.txt") ;
   
   // set marker size and style
   gr->SetMarkerStyle(21) ;
   gr->SetMarkerSize(0.8) ;
   
   
   // set line width and style
   //gr->SetLineWidth(1) ; 
   //gr->SetLineStyle(1) ; 
   
   // plot title
   gr->SetTitle("plot title") ;
   
   // x-axis setup
   gr->GetXaxis()->SetTitle("x-axis [unit]") ;
   gr->GetXaxis()->CenterTitle() ;
   //gr->GetXaxis()->SetRangeUser(...) ;
   //gr->GetXaxis()->SetNdivisions(...) ;
   //gr->GetXaxis()->SetTickLength(...) ;
   //gr->GetXaxis()->SetLabelOffset(...) ;
   //gr->GetXaxis()->SetLabelSize(...) ;  
   //gr->GetXaxis()->SetLabelFont(...) ; 
   //gr->GetXaxis()->SetTitleSize(...) ;   
   //gr->GetXaxis()->SetTitleFont(...) ;
   //gr->GetXaxis()->SetTitleOffset(...) ;

   
   // y-axis setup
   gr->GetYaxis()->SetTitle("y-axis [unit]") ;
   gr->GetYaxis()->CenterTitle() ;   
   //gr->GetYaxis()->SetRangeUser(...) ;
   //gr->GetYaxis()->SetNdivisions(...) ;
   //gr->GetYaxis()->SetTickLength(...) ;
   //gr->GetYaxis()->SetLabelOffset(...) ;
   //gr->GetYaxis()->SetLabelSize(...) ;  
   //gr->GetYaxis()->SetLabelFont(...) ; 
   //gr->GetYaxis()->SetTitleSize(...) ;   
   //gr->GetYaxis()->SetTitleFont(...) ;
   //gr->GetYaxis()->SetTitleOffset(...) ;



   // draw the object (a new TCanvas in created by default)   
   gr->Draw("AP") ;            // Axis and Points
   //gr->Draw("ALP") ;         // Axis, Points and a straight Line segments between points
   //gr->Draw("ACP") ;         // Axis, Points and a Curve line between points


   // optionally, FIT experimental data with a pre-defined function

   double xMin = 0.0 ;
   double xMax = 12.0 ;
   
   gr->Fit("pol1", "", "", xMin, xMax) ;         // linear fit (pol2 = quadratic fit, pol3 = cubic fit etc.)
   
   
   // show fit results
   gStyle->SetOptFit(1) ;
   
   
   // update the canvas
   gPad->Modified();
   gPad->Update();
   
   
} // end script


