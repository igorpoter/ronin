classpath "."

uses gw.lang.cli.CommandLineAccess
uses java.io.File
uses java.lang.System
uses gw.vark.Aardvark

/* Initialize a Ronin application */
function init() {
  var args = {"my_app"} /* TODO args in aardvark */
  if( args.Count != 1 ) {
    logError( "Usage: roninit <my_app_name>" )
    System.exit( -1 )
  }

  var rootDir = new File(args[0])
  if(rootDir.exists()) {
    logError( rootDir + " already exists" )
    System.exit( -1 )
  }

  rootDir.mkdir()
  rootDir.getChild( "build.vark" ).write( templates.InitVarkFile.renderToString() )
  
  //============================================================================
  // /src
  //============================================================================
  rootDir.getChild( "src" ).mkdir()
  rootDir.getChild( "src/controller" ).mkdir()
  rootDir.getChild( "src/controller/Main.gs" ).write( templates.MainController.renderToString() )
  rootDir.getChild( "src/config" ).mkdir()
  rootDir.getChild( "src/config/RoninConfig.gs" ).write( templates.RoninConfig.renderToString() )
  rootDir.getChild( "src/view" ).mkdir()
  rootDir.getChild( "src/view/Main.gst" ).write( "<html><body><h1>Welcome To Ronin!</h1></body></html>" )
  rootDir.getChild( "src/db" ).mkdir()
  rootDir.getChild( "src/db/main.dbc" ).write( "jdbc:h2:file:./runtime/h2" )

  //============================================================================
  // /lib
  //============================================================================
  Ant.copy( :filesetList = {file("..").fileset( :includes="lib/**") },
            :todir = rootDir )
  
  //============================================================================
  // /test
  //============================================================================
  rootDir.getChild( "test" ).mkdir()

  //============================================================================
  // /html
  //============================================================================
  var webInf = rootDir.getChild( "html/WEB-INF" )
  webInf.mkdirs()
  webInf.getChild( "web.xml" ).write( templates.WebXml.renderToString() )

  //============================================================================
  // /db
  //============================================================================
  var db = rootDir.getChild( "db" )
  db.mkdir()
  db.getChild( "init.sql" ).write( templates.InitDB.renderToString() )

  //============================================================================
  // /support
  //============================================================================
  Ant.copy( :filesetList = {file("..").fileset( :includes="support/**") },
            :todir = rootDir )

  log( "A ronin application was created at ${rootDir.AbsolutePath}.  To start the application:\n\n  cd ${rootDir.AbsolutePath}\n  vark server" )
}