requires "Browser::Open" => "0";
requires "Carp" => "0";
requires "File::pushd" => "0";
requires "Git::Sub" => "0";
requires "Sub::Exporter" => "0";
requires "Try::Tiny" => "0";
requires "URI" => "0";
requires "URI::FromHash" => "0";
requires "URI::Heuristic" => "0";
requires "URI::git" => "0";
requires "perl" => "5.006";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "File::Temp" => "0";
  requires "Git::Version" => "0";
  requires "Test::Fatal" => "0";
  requires "Test::Git" => "1.313";
  requires "Test::More" => "0";
  requires "Test::Requires::Git" => "1.005";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::Code::TidyAll" => "0.24";
  requires "Test::More" => "0.88";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Synopsis" => "0";
};
