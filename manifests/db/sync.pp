#
# Class to execute glare-db-manage
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the glare-db-manage command.
#   Defaults to '--config-file /etc/glare.conf'
#

class glare::db::sync(
  $extra_params  = '',
) {
  include ::glare::deps

  exec { 'glare-db-sync':
    command     => "glare-db-manage ${extra_params} upgrade",
    user        => 'glare',
    path        => [ '/bin/', '/usr/bin/' , '/usr/local/bin' ],
    refreshonly => true,
    subscribe   => [
      Anchor['glare::install::end'],
      Anchor['glare::config::end'],
      Anchor['glare::dbsync::begin']
    ],
    notify      => Anchor['glare::dbsync::end'],
  }
  Exec['glare-db-sync'] ~> Service<| title == 'glare' |>
}
