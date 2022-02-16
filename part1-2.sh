tpm2_flushcontext -t

tpm2_createek -G rsa -u rsaek.pub -c ek.ctx
tpm2_sign -c ek.ctx -g sha256 -o sig.rssa message.dat
