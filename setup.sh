tpm2_flushcontext -t

tpm2_createprimary -C e -c primary.ctx
tpm2_create -G rsa -u rsa.pub -r rsa.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u rsa.pub -r rsa.priv -c rsa.ctx

echo "data_to_sign" > message.dat
sha256sum dummy.txt | awk '{ print "000000 " $1 }' | xxd -r -c 32 > data.in.digest

tpm2_flushcontext -t

tpm2_sign -c rsa.ctx -g sha256 -o sig.rssa message.dat
tpm2_verifysignature -c rsa.ctx -g sha256 -s sig.rssa -m message.dat
