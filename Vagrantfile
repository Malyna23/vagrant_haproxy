servers=[
  {
    :hostname => "haproxy",
    :ip => "192.168.56.2",
    :box => "centos/7",
    :ram => 1024,
    :cpu => 1,
    :path => "scenario_haproxy.sh"
  },
  {
    :hostname => "db",
    :ip => "192.168.56.4",
    :box => "centos/7",
    :ram => 1024,
    :cpu => 1,
    :path => "scenario_db.sh"
  },
  {
    :hostname => "web",
    :ip => "192.168.56.3",
    :box => "centos/7",
    :ram => 1024,
    :cpu => 1,
    :path => "scenario_web.sh"
  },
  {
    :hostname => "web1",
    :ip => "192.168.56.6",
    :box => "centos/7",
    :ram => 1024,
    :cpu => 1,
    :path => "scenario_web1.sh"
  }
]

Vagrant.configure(2) do |config|
  servers.each do |machine|
      config.vm.define machine[:hostname] do |node|
          node.vm.box = machine[:box]
          node.vm.hostname = machine[:hostname]
          node.vm.network "private_network", ip: machine[:ip]
          node.vm.network "public_network", machine
          node.vm.provider "virtualbox" do |vb|
              vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
          end
          node.vm.provision "shell", path: machine[:path]
      end
  end
end