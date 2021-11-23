job('test-gradle-ci') {
    description 'Build and test the app.'
    scm {
        github 'atrillanes1972/job-dsl-playground'
    }
    steps {
        gradle 'test'
    }
    publishers {
        archiveJunit 'build/test-results/**/*.xml'
    }
}