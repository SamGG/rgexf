## Test environments

* Local: Ubuntu 18.04.4 LTS, R 3.6.2
* Travis: Ubuntu 16.04.6 LTS, R 3.6.2
* Travis: Ubuntu 16.04.6 LTS, R Under development (unstable) (2020-02-10 r77788)
* Travis: macOS Mojave 10.14.4, R 3.6.2
* AppVeyor: Windows Server 2012 R2 x64, R 3.5.3
* AppVeyor: Windows Server 2012 R2 x64, R 3.6.2
* AppVeyor: Windows Server 2012 R2 x64, R Under development (unstable) (2020-02-10 r77789)

## R CMD check results

* This package was taken out of CRAN due to a memleak issue. This issue has been
  solved, and furthermore, the package contains no C/C++ or any other type of
  code that needs to be compiled. The functions were re-written using base R.

* No reverse dependencies to be checked.

