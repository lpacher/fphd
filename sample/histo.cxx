//
// Minimal ROOT un-named script to test software installation.
// Command line usage:
//
//   % cd Desktop/lae
//   % root sample/histo.cxx
//
// You can also start an interactive ROOT session and then execute
// the script at the ROOT command prompt:
//
//   % cd Desktop/lae
//   % root
//   root[] .x sample/histo.cxx
//
// Luca Pacher - pacher@to.infn.it
// Spring 2020
//


{

   gROOT->Reset() ;

   const int Ntrials = 10000 ;

   TH1F histo("histo","MC example", 100, -5, 5) ;

   // keep track of Poisson errors on bin entries
   histo.Sumw2() ;

   // generate normally-distributed random values
   histo.FillRandom("gaus", Ntrials) ;

   // normalize the distribution to unit area
   histo.Scale(1.0/histo.GetEntries()) ;

   histo.Draw() ;

   histo.Fit("gaus") ;

   // display fit results
   gStyle->SetOptFit(1) ;

   // save histogram to ROOT file
   TFile fout("histo.root","RECREATE") ;

   histo.Write() ;

   fout.Close() ;

}
