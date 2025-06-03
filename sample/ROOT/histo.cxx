//
// Minimal ROOT un-named script to test software installation.
// Command line usage:
//
//   % cd Desktop/lae
//   % root sample/ROOT/histo.cxx
//
// You can also start an interactive ROOT session and then execute
// the script at the ROOT command prompt:
//
//   % cd Desktop/lae
//   % root
//   root[] .x sample/ROOT/histo.cxx
//
// Luca Pacher - pacher@to.infn.it
// Spring 2020
//


{

   // reset the ROOT interactive environment 
   gROOT->Reset() ;   // **NOTE: useful at the beginning of an un-named script that you want to execute multiple times interactively

   const int Ntrials = 10000 ;

   TH1F histo("histo","MC example", 100, -5, 5) ;

   // keep track of Poisson errors on bin entries
   histo.Sumw2() ;

   // generate normally-distributed random values
   histo.FillRandom("gaus", Ntrials) ;

   // normalize the distribution to unit area
   histo.Scale(1.0/histo.GetEntries()) ;

   // draw the histogram with error bars
   histo.Draw("E") ;

   // gaussian fit
   histo.Fit("gaus") ;

   // display fit results
   gStyle->SetOptFit(1) ;

   // create new ROOT file
   TFile fout("histo.root","RECREATE") ;

   // save the histogram to ROOT file
   histo.Write() ;

   // close the file handler
   fout.Close() ;

}
