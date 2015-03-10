require 'serverspec'

set :backend, :exec
set :path, "/sbin:/usr/sbin:$PATH"
