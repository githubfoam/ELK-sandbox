job('seedjob test 1') {
    steps {
        shell('''
        	echo "seedjob testing"
    	'''.stripIndent())
    }
}