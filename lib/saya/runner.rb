
require 'saya'

module Saya::Runner
  module_function
  def options
    @options ||=
    [['ruby options:'      , ''                                       ],
     ['-e, --eval LINE'                                                ,
      'Evaluate a LINE of code'                                       ],

     ['-d, --debug'                                                    ,
      'Set debugging flags (set $DEBUG to true)'                      ],

     ['-w, --warn'                                                     ,
       'Turn warnings on (set $-w to true)'                           ],

     ['-I, --include PATH'                                             ,
       'Specify $LOAD_PATH (may be used more than once)'              ],

     ['-r, --require LIBRARY'                                          ,
       'Require the library, before executing'                        ],

     ['saya options:'      , ''                                       ],
     ['-s, --server SERVER', 'Serve using SERVER'                     ],
     ['-o, --host HOST'    , 'Listen on HOST (default: 0.0.0.0)'      ],
     ['-p, --port PORT'    , 'Use PORT (default: 8080)'               ],
     ['-E, --env RACK_ENV' , 'Use RACK_ENV (default: production)'     ],
     ['-D, --daemonize'    , 'Run daemonized in the background'       ],
     ['-a, --auth PATH'    , 'Use AUTH file to specify key/secret'    ],
     ['-c, --config.ru'    , 'Print the path to config.ru'            ],
     ['-h, --help'         , 'Print this message'                     ],
     ['-v, --version'      , 'Print the version'                      ]]
  end

  def run argv=ARGV
    o = parse(argv)
    u = %w[zbatery rainbows unicorn]
    app, _ = Rack::Builder.parse_file(o[:config])

    handler = if ( u.include?(o[:server]) && rack_handlers(o[:server])) ||
                 (!u.include?(o[:server]) && o[:server])
      Rack::Handler.get(o[:server])
    else
      Rack::Handler.pick(u + %w[puma thin webrick])
    end

    Process.daemon && $0 = 'saya' if o[:daemonize]
    handler.run(wrap_app(app), o)
  end

  def rack_handlers server
    gem 'rack-handlers'
    true
  rescue Gem::LoadError
    warn("Install gem `\e[31mrack-handlers\e[0m' to run #{server} server")
    false
  end

  def wrap_app app
    case ENV['RACK_ENV']
    when 'development', 'dev'
      Rack::CommonLogger.new(Rack::Lint.new(Rack::ShowExceptions.new(app)))
    else
      app
    end
  end

  def parse argv
    options = {:Host => '0.0.0.0', :Port => 8080, :config => Saya::Config}

    until argv.empty?
      case arg = argv.shift
      when /^-e=?(.+)?/, /^--eval=?(.+)?/
        eval($1 || argv.shift, TOPLEVEL_BINDING, __FILE__, __LINE__)

      when /^-d/, '--debug'
        $DEBUG = true
        argv.unshift("-#{arg[2..-1]}") if arg.size > 2

      when /^-w/, '--warn'
        $-w, $VERBOSE = true, true
        argv.unshift("-#{arg[2..-1]}") if arg.size > 2

      when /^-I=?(.+)?/, /^--include=?(.+)?/
        paths = ($1 || argv.shift).split(':')
        $LOAD_PATH.unshift(*paths)

      when /^-r=?(.+)?/, /^--require=?(.+)?/
        require($1 || argv.shift)

      when /^-s=?(.+)?/, /^--server=?(.+)?/
        options[:server] = $1 || argv.shift

      when /^-o=?(.+)?/, /^--host=?(.+)?/
        options[:Host] = $1 || argv.shift

      when /^-p=?(.+)?/, /^--port=?(.+)?/
        options[:Port] = $1 || argv.shift

      when /^-E=?(.+)?/, /^--env=?(.+)?/
        ENV['RACK_ENV'] = $1 || argv.shift

      when /^-D/, '--daemonize'
        options[:daemonize] = true

      when /^-a=?(.+)?/, /^--auth=?(.+)?/
        ENV['SAYA_AUTH'] = $1 || argv.shift

      when /^-c/, '--config.ru'
        puts(options[:config])
        exit

      when /^-h/, '--help'
        puts(help)
        exit

      when /^-v/, '--version'
        require 'saya/version'
        puts(Saya::VERSION)
        exit

      else
        warn("Unrecognized option: #{arg}")
        exit(1)
      end
    end

    options
  end

  def help
    maxn = options.transpose.first.map(&:size).max
    maxd = options.transpose.last .map(&:size).max
    "Usage: saya [ruby OPTIONS] [saya OPTIONS]\n" +
    options.map{ |(name, desc)|
      if name.end_with?(':')
        name
      else
        sprintf("  %-*s  %-*s", maxn, name, maxd, desc)
      end
    }.join("\n")
  end
end
