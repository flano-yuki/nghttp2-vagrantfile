#
# Cookbook Name:: nghttp2
# Recipe:: default
#
#
#directory "/root/.config/git/" do
#  recursive true
#end

%w!git autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev!.each do |p|
  package p
end

git "/home/vagrant/nghttp2" do
  repository "https://github.com/tatsuhiro-t/nghttp2.git"
  user "vagrant"
  group "vagrant"
end

execute "build nghttp2" do
  command <<-"EOS"
cd /home/vagrant/nghttp2
autoreconf -i
automake
autoconf
autoreconf -i
autoconf
./configure
make
EOS
  user "vagrant"
end
