#
# Cookbook Name:: nghttp2
# Recipe:: default
#

#disable ipv6
ruby_block "edit /etc/sysctl.conf" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/sysctl.conf")
    rc.insert_line_if_no_match(/disable_ipv6/, <<-"EOS")
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOS
    rc.write_file
  end
  notifies :run, "execute[sysctl -p]", :immediately
end

execute "sysctl -p" do
  action :nothing
end


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
./configure
make
EOS

end
