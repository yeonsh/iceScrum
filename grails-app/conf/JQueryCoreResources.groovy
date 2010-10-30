modules = {
  'jquery' {
    resource url: [plugin: 'jquery', dir: 'js/jquery', file: 'jquery-1.4.3.min.js'], nominify: true, disposition: 'head',bundle:'jquery-plugins'
  }
  'jquery-ui' {
    dependsOn 'jquery'
    resource url: [
           plugin:'jquery-ui', dir: 'jquery-ui/js', file: 'jquery-ui-1.8.5.custom.min.js'], nominify: true, disposition: 'head',bundle:'jquery-plugins'
  }
}