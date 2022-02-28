tpm2_flushcontext -t

tpm2_createek -G rsa -c ek.ctx
tpm2_create -G rsa -u ek.pub -r ek.priv -C ek.ctx

tpm2_flushcontext -t

tpm2_load -C ek.ctx -u ek.pub -r ek.priv -c rsaek.ctx

tpm2_flushcontext -t

tpm2_sign -c rsaek.ctx -g sha256 -o sigek.rssa message.dat
tpm2_verifysignature -c rsaek.ctx -g sha256 -s sigek.rssa -m message.dat
