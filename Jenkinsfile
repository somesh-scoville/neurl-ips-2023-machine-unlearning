#!/usr/bin/env groovy

library 'scoville-jenkins-libs'


pipeline {

  options {
    ansiColor('xterm')
  }

  environment {
    PYTHON_MODULE = 'age_unlearning'
  }

  agent {
    dockerfile {
      filename 'docker/jenkins/Dockerfile'
      additionalBuildArgs '--build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID}' \
        + ' --build-arg AUX_GROUP_IDS="${AUX_GROUP_IDS}"'
      args '--group-add 997 -v "/var/run/docker.sock:/var/run/docker.sock"'
    }
  }

  stages {

    stage('Lint') {
      environment {
        PYTHON_MODULES = 'age_unlearning'
        MYPY_ARGS = '--ignore-missing-imports'
      }
      steps {
        sh """#!/usr/bin/env bash
          set -Eeux
          python3 -m pylint ${PYTHON_MODULES} |& tee pylint.log
          echo "\${PIPESTATUS[0]}" | tee pylint_status.log
          python3 -m mypy ${MYPY_ARGS} ${PYTHON_MODULE} |& tee mypy.log
          echo "\${PIPESTATUS[0]}" | tee mypy_status.log
          python3 -m flake518 ${PYTHON_MODULES} |& tee flake518.log
          echo "\${PIPESTATUS[0]}" | tee flake518_status.log
        """
      }
    }

    stage('Test') {
      steps {
        sh '''#!/usr/bin/env bash
          set -Eeuxo pipefail
          default_working_directory=`pwd`
          cd ${PYTHON_MODULE}
          python3 -m coverage run --branch --source . -m pytest -v
          cp .coverage ${default_working_directory}/.coverage
        '''
      }
    }

    stage('Coverage') {
      steps {
        sh '''#!/usr/bin/env bash
          set -Eeux
          python3 -m coverage report --ignore-errors --show-missing |& tee coverage.log
          echo "${PIPESTATUS[0]}" | tee coverage_status.log
        '''
      }
    }
  }

  post {
    unsuccessful {
      script {
        defaultHandlers.afterBuildFailed()
      }
    }
    regression {
      script {
        defaultHandlers.afterBuildBroken()
      }
    }
    fixed {
      script {
        defaultHandlers.afterBuildFixed()
      }
    }
    always {
      script {
        defaultHandlers.afterPythonBuild()
      }
    }
  }
}
