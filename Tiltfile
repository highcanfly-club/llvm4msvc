Namespace='sandbox'

default_registry('ttl.sh/sanbox-llvm-17az3650')
Registry='ttl.sh/sanbox-llvm-17az3650'

allow_k8s_contexts('kubernetesOCI')

#Registry='registry.oci.sctg.eu.org'
#default_registry(Registry)

os.putenv ( 'DOCKER_USERNAME' , 'ociregistry' ) 
os.putenv ( 'DOCKER_PASSWORD' , 'eiFooxoh8h4e' ) 
os.putenv ( 'DOCKER_EMAIL' , 'none@example.org' ) 
os.putenv ( 'DOCKER_REGISTRY' , Registry ) 
os.putenv('NAMESPACE',Namespace)

# docker_build('highcanfly/llvm4msvc:latest', '.', entrypoint='/bin/bash')

k8s_yaml('./test/test.yaml')

custom_build('highcanfly/llvm4msvc','./kaniko-build.sh',[
  './test'
],skips_local_docker=True, 
  live_update=[
    sync('./test', '/usr/share/msvc/test')
])

