#
define systemd::service (
    String $execstart,
    String $servicename      = $name,
    String $description      = '',
    String $execstop         = undef,
    String $execreload       = undef,
    String $workingdir       = undef,
    String $restart          = 'always',
    String $restartsec       = undef,
    Boolean $remainafterexit = false,
    String $user             = 'root',
    String $group            = 'root',
    String $type             = 'simple',
    Boolean $defaultdeps     = true,
    Array $requires          = [],
    Array $conflicts         = [],
    Array $wants             = [],
    Array $after             = [],
    Array $wantedby          = ['multi-user.target'],
    String $unit_path        = $systemd::params::unit_path,
    Array $confopts          = undef,
) {

    include systemd

    validate_re($restart, ['^always$', '^no$', '^on-(success|failure|abnormal|abort|watchdog)$'], "Not a supported restart type: ${restart}")
    validate_re($type, ['^simple$', '^forking$', '^oneshot$', '^dbus$', '^notify$', '^idle$'], "Not a supported type: ${type}")


    file { "${unit_path}/${servicename}.service":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/service.erb"),
        notify  => Exec['systemd-daemon-reload'],
    }
}
