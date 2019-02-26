# jx-app-jenkins

This App is for running any kind of Jenkins server inside Jenkins X. 

This App is intended to be used with the `--ng` kind of Jenkins X cluster so that traditional Jenkins X build packs will default to using tekton pipelines and then any traditional `Jenkinsfile` based pipelines will be delegated to this Jenkins App.

## Installing 

The Jenkins App can be installed by running:

`jx add app jx-app-jenkins`

It will ask you what plugins you want to add to the Jenkins server when you install the app.


