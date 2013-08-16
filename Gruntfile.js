module.exports = function(grunt) {

  grunt.initConfig({
    watch: {
      // Watch some coffeescripts!
      bot: {files: ['**/*.coffee'], tasks: ['coffee:bot']}
    },
    coffee: {
      bot: {
        options: {bare: true},
        expand: true,
        cwd: 'coffee',
        src: ['**/*.coffee'],
        dest: 'js/',
        ext: '.js'
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  grunt.registerTask('default', ['coffee']);
  grunt.registerTask('dev', ['coffee', 'watch']);
};
