include_recipe "runit"

package "git"
package "mercurial"
package "bzr"
package "build-essential"
package "make"

directory "/opt/drone/src/github.com/drone/" do
  recursive true
end

git "/opt/drone/src/github.com/drone/drone" do
  repository "git://github.com/vito/drone.git"
  action :sync
end

execute "build drone" do
  cwd "/opt/drone/src/github.com/drone/drone"
  environment("GOPATH" => "/opt/drone")

  command "make deps && PATH=$GOPATH/bin:$PATH make"
end

runit_service "droned"
