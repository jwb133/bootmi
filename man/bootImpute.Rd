% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bootImpute.R
\name{bootImpute}
\alias{bootImpute}
\title{Bootstrap then impute an incomplete dataset}
\usage{
bootImpute(
  obsdata,
  impfun,
  nBoot = 200,
  nImp = 2,
  nCores = 1,
  seed = NULL,
  ...
)
}
\arguments{
\item{obsdata}{The data frame to be imputed.}

\item{impfun}{A function which when passed an incomplete dataset will
return a single imputed data frame.}

\item{nBoot}{The number of bootstrap samples to take. It is recommended
that you use a minimum of 200. If you specify \code{nCores>1}, \code{nBoot} must
be a multiple of the specified \code{nCores} value.}

\item{nImp}{The number of times to impute each bootstrap sample. Two
is recommended.}

\item{nCores}{The number of CPU cores to use. If specified greater than one,
\code{bootImpute} will impute using the number of cores specified.}

\item{seed}{Random number seed.}

\item{...}{Other parameters that are to be passed through to \code{impfun},
which will often include the argument that tells \code{impfun} to generate
as many imputations as specified by the value passed to \code{nImp}.}
}
\value{
A list of imputed datasets.
}
\description{
Bootstraps an incomplete dataset and then imputes each bootstrap a number
of times. The resulting list of bootstrapped then imputed datasets can
be analysed with \code{\link{bootImputeAnalyse}}.
}
\details{
The \code{impfun} must be a function which when passed an incomplete datasets
and possibly additional arguments, returns a list of (e.g. 2) imputed datasets.
The number of imputed datasets that \code{impfun} returns should match the value
you specify for the argument \code{nImp}. Depending on what your imputation function
returns by default, you may need to write a small wrapper function that calls
the imputation procedure and returns the list of \code{nImp} datasets.See the
Example for an illustration with the \code{mice} package.

To improve computation times, \code{bootImpute} now supports
multiple cores through the \code{nCores} argument which uses the \code{parallel}
package.
}
\examples{
#this example shows how you can use bootImpute to impute using the mice
#package. If you do want to impute using MICE you can instead use the
#bootMice function, which essentially contains the code below
library(mice)

#write a wrapper function to call mice generating M imputations
impM <- function(inputData,M) {
  miceImps <- mice::mice(inputData, m=M)
  imps <- vector("list", M)
  for (i in 1:M) {
    imps[[i]] <- mice::complete(miceImps,i)
  }
  imps
}

#bootstrap twice and impute each twice
#in practice you should bootstrap many more times, e.g. at least 200
#note you have to tell bootImpute how many imputations per bootstrap in
#nImp=2 and also pass through whatever your imp function argument is called
#for specifying number of imputations, which here is M=2.
imps <- bootImpute(ex_linquad, impM, nBoot=2, nImp=2, M=2, seed=564764)
}
