# svn-docker-builder
OpenShift 3 Docker Builder which fetches sources from Subversion

The included template `svn-docker-builder.json` helps to create applications based on this builder.

## Template Parameters
The included template `svn-docker-builder.json` supports the following parameters:

  * APPLICATION_NAME: Name of the created application
  * APPLICATION_HOSTNAME: Custom hostname for service routes. Leave blank for default hostname, e.g.: _application-name_-_project_._default-domain-suffix_
  * SOURCE_REPOSITORY: URL of SVN repository. The builder expects to find `Dockerfile` and Docker context in the root directory of the working copy.
  
## Usage

Register the template on OpenShift:

    oc create -n openshift -f https://raw.githubusercontent.com/puzzle/svn-docker-builder/master/svn-docker-builder.json

Update existing template:

    oc replace -n openshift -f https://raw.githubusercontent.com/puzzle/svn-docker-builder/master/svn-docker-builder.json

Create application based on template:

    oc process -n openshift svn-docker-builder -v 'TEMPLATE_ARGUMENTS' | \
        oc create -f -

e.g.:

    oc process -n openshift svn-docker-builder -f svn-docker-builder -v 'APPLICATION_NAME=test,SOURCE_REPOSITORY=https://github.com/puzzle/openshift3-docker-hello.git/branches/svn-docker-builder' | \
        oc create -f -

This example makes use of the fact that you can checkout GitHub repositories via Subversion.

