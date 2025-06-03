//
// Simple un-named ROOT script to plot and fit a set of y-data vs. x-data
// experimental values stored into standard C/C++ arrays. 
//
// Execute the script at the ROOT command prompt with:
//
//    root[] .x plotDataArray.cxx
//
// Luca Pacher - pacher@to.infn.it
// Spring 2016
//


{
   gROOT->Reset() ;

   //
   // **NOTE
   // As a common practice, ROOT GUI objects are usually allocated on the HEAP with the C++ "new" operator
   // to ensure object persistence outside a function. In simple un-named scripts (interactive environment)
   // static objects and dynamically-allocated objects with pointers are basically equivalent solutions.
   //

   //TGraph  gr(Npt,xData,yData) ;
   //TGraph  *gr = new TGraph(Npt,xData,yData) ;


   // number of (x,y) experimental values
   int Npt = 5 ;

   TGraph *gr1 = new TGraph(Npt) ;
   TGraph *gr2 = new TGraph(Npt) ;

   double xData[Npt] = { 283    , 567    , 849    , 1133    , 1415     } ;   // number of inverting stages in the loop
   double yData[Npt] = { 3.35e6 , 1.95e6 , 1.42e6 , 1.088e6 , 863.8e3  } ;   // measured toggle frequency

   for(int k=0; k < Npt; ++k) {

      gr1->SetPoint(k,(xData[k]+1),yData[k]) ;
      gr2->SetPoint(k,1/(xData[k]+1),yData[k]) ;
   }


   // set marker size and style
   gr1->SetMarkerStyle(21) ; gr2->SetMarkerStyle(22) ;
   gr1->SetMarkerSize(0.8) ; gr2->SetMarkerStyle(21) ;


   // set line width and style
   //gr->SetLineWidth(1) ; 
   //gr->SetLineStyle(1) ; 

   // plot title
   gr1->SetTitle("frequency vs (N+1)") ; gr2->SetTitle("frequency vs 1/(N+1)") ;

   // x-axis setup
   //gr->GetXaxis()->SetTitle("x-axis [unit]") ;
   //gr->GetXaxis()->CenterTitle() ;
   //gr->GetXaxis()->SetRangeUser(...) ;
   //gr->GetXaxis()->SetNdivisions(...) ;
   //gr->GetXaxis()->SetTickLength(...) ;
   //gr->GetXaxis()->SetLabelOffset(...) ;
   //gr->GetXaxis()->SetLabelSize(...) ;  
   //gr->GetXaxis()->SetLabelFont(...) ; 
   //gr->GetXaxis()->SetTitleOffset(...) ;
   //gr->GetXaxis()->SetTitleSize(...) ;   
   //gr->GetXaxis()->SetTitleFont(...) ; 

   // y-axis setup
   //gr->GetYaxis()->SetTitle("y-axis [unit]") ;
   //gr->GetYaxis()->CenterTitle() ;   
   //gr->GetYaxis()->SetRangeUser(...) ;
   //gr->GetYaxis()->SetNdivisions(...) ;
   //gr->GetYaxis()->SetTickLength(...) ;
   //gr->GetYaxis()->SetLabelOffset(...) ;
   //gr->GetYaxis()->SetLabelSize(...) ;  
   //gr->GetYaxis()->SetLabelFont(...) ; 
   //gr->GetYaxis()->SetTitleOffset(...) ;
   //gr->GetYaxis()->SetTitleSize(...) ;   
   //gr->GetYaxis()->SetTitleFont(...) ; 

   //gr->Draw("ALP") ;

   TCanvas *c1 = new TCanvas("c1","Ring-oscillator frequency study",800,400) ;

   c1->Divide(2,1) ;

   c1->cd(1) ;
   gr1->Draw("ALP") ;

   c1->cd(2) ;
   gr2->Draw("ALP") ;

}   // end script

