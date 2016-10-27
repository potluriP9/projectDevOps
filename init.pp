ec2_vpc{ 'PotluriVPC':
ensure  => present,
region => 'us-east-1',
instance_tenancy => 'default',
cidr_block => '10.0.0.0/16',
}
ec2_vpc_subnet { 'PotluriSubNet' :
ensure => present,
vpc => 'PotluriVPC',
region => 'us-east-1',
availability_zone   => 'us-east-1a',
cidr_block => '10.0.0.0/24',
route_table => 'PotluriRoute',
}
ec2_vpc_internet_gateway{ 'PotluriIGW' :
ensure => present,
region => 'us-east-1',
vpc => 'PotluriVPC',
}
ec2_vpc_routetable{ 'PotluriRoute':
ensure => present,
region => 'us-east-1',
vpc => 'PotluriVPC',
routes => [
    {
      destination_cidr_block => '10.0.0.0/16',
      gateway                => 'local'
    },{
      destination_cidr_block => '0.0.0.0/0',
      gateway                => 'PotluriIGW'
    },
  ],
}  
ec2_securitygroup { 'PotluriSecurity':
  ensure      => present,
  region      => 'us-east-1',
  description => 'Security Purpose',
  subnet      => 'PotluriSubNet',
  vpc         => 'PotluriVPC',
  ingress     => [{
    protocol  => 'tcp',
    port      => 80,
    cidr      => '0.0.0.0/0',
#  },{
#    security_group => 'other-security-group',
  }],
#  tags        => {
#    tag_name  => 'value',
#  },
}
ec2_instance { 'PotluriWebServer1':
  ensure            => present,
  region            => 'us-east-1',
  availability_zone => 'us-east-1a',
  image_id          => 'ami-d732f0b7',
  instance_type     => 't2.micro',
  monitoring        => true,
  key_name          => 'sample',
  subnet 			=> 'PotluriSubNet',
  security_groups   => ['PotluriSecurity'],
  user_data         => template('bootstrapingscript.sh'),
#  tags              => {
#    tag_name => 'value',
#  },
}
ec2_instance { 'PotluriWebServer2':
  ensure            => present,
  region            => 'us-east-1',
  availability_zone => 'us-east-1b',
  image_id          => 'ami-d732f0b7',
  instance_type     => 't2.micro',
  monitoring        => true,
  key_name          => 'sample',
  subnet 			=> 'PotluriSubNet',
  security_groups   => ['PotluriSecurity'],
  user_data         => template('bootstrapingscript.sh'),
#  tags              => {
#    tag_name => 'value',
#  },
}

elb_loadbalancer { 'PotluriLoadBalancer':
  ensure               => present,
  region               => 'us-east-1',
  availability_zones   => ['us-east-1a', 'us-east-1b'],
  instances            => ['PotluriWebServer1', 'PotluriWebServer2'],
  security_groups      => ['PotluriSecurity'],
  listeners            => [{
    protocol           => 'HTTP',
    load_balancer_port => 80,
    instance_protocol  => 'HTTP',
    instance_port      => 80,
  },{
    protocol           => 'HTTPS',
    load_balancer_port => 443,
    instance_protocol  => 'HTTPS',
    instance_port      => 8080,
    ssl_certificate_id => 'arn:aws:acm:us-east-1:486937649306:certificate/185e4a7e-e03d-4d2e-876e-2he623601d23',
  }],
  tags                 => {
    tag_name => 'value',
  },
}

