sudo apt-get remove scala-library scala
VER=2.11.6 # look into http://www.scala-lang.org/files/archive/ for the latest version
wget http://www.scala-lang.org/files/archive/scala-$VER.deb
sudo dpkg -i scala-$VER.deb
sudo apt-get update
sudo apt-get install scala

sudo apt-get purge sbt
VER=0.13.8 # look into http://dl.bintray.com/sbt/debian/ for the latest version
wget http://dl.bintray.com/sbt/debian/sbt-$VER.deb
sudo dpkg -i sbt-$VER.deb 
sudo apt-get update
sudo apt-get install sbt
#
