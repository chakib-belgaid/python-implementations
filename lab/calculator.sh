read startp
read startwu
read endwu
read endp

startp=${startp##*-}
startwu=${startwu##*-}
endwu=${endwu##*-}
endp=${endp##*-}



echo startp: $startp
echo startwu: $startwu
echo endwu: $endwu
echo endp: $endp

echo ---------------

beginingtime=$(( $startwu - $startp ))
globaltime=$(( $endp - $startp ))
warmuptime=$(( $endwu - $startwu ))
executiontime=$(( $endp - $endwu ))


echo beginingtime: $beginingtime
echo globaltime: $globaltime
echo warmuptime: $warmuptime
echo executiontime: $executiontime