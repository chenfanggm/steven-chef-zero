#! /bin/bash
if [[ :$PATH: == *:/usr/local/nodejs-binary-5.1.0/bin:* ]]; then
   echo '# O.K., the directory /usr/local/nodejs-binary-5.1.0/bin is already in the path'
else
   echo 'PATH before change...'
   echo $PATH
   export PATH=$PATH:/usr/local/nodejs-binary-5.1.0/bin
   echo 'PATH after change...'
   echo $PATH
   echo 'export PATH=$PATH:/usr/local/nodejs-binary-5.1.0/bin'  >> ~/.bash_profile
fi
