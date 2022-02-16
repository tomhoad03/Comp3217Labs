for i in {0..9999}
do
	tpm2_flushcontext -t
	session:sessionSrk.dat+$i
	echo $i
done
