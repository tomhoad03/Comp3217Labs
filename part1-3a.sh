tpm2_flushcontext -t

tpm2_createprimary -C e -c primarySrk.ctx
tpm2_create -G rsa -u rsaSrk.pub -r rsaSrk.priv -C primarySrk.ctx

tpm2_flushcontext -t

tpm2_startauthsession -S sessionSrk.dat

tpm2_changeauth -C o -r rsaSrkP.pub -c rsaSrk.pub 9854
#tpm2_changeauth -C o -r rsaSrkP.priv -c rsaSrk.priv 9854 
#tpm2_changeauth -C o -r primarySrkP.ctx -c primarySrk.ctx 9854 
