
BEGIN{
 str=strftime("%b.%d.%Y")
 comment="ckino " str ": "
}

/^ .*iv_p_oindxo/{
 st="sham%"
 po="iv_p_oindxo"
 al="iv_a_oindxo"
 ty="integer"
 print comment,$0
 ty_sub=ty
 sub("\\(","\\(",ty_sub)
 sub("\\)","\\)",ty_sub)
 gsub(ty_sub " *, *pointer *::",ty " , allocatable ::")
 gsub("=>NULL\\(\\)","")
 gsub(po,al)
 if (match($0,"nullify")) { 
  print "        if (allocated(" st al ")) deallocate(" st al ")"
  next; 
 }
 if (match($0,"allocate\\(" st po)) {
  print "        if (allocated("st al")) deallocate(" st al ")"
 }

 gsub("associated\\(","allocated(")
}
{print}
