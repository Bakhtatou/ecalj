
BEGIN{
 str=strftime("%b.%d.%Y")
 comment="ckino " str ": "
}

/^ .*rv_p_osop/{

 st="spot%"
 po="rv_p_osop"
 al="rv_a_osop"
 ty="real(8)"

 print comment,$0
 ty_sub=ty
 sub("\\(","\\(",ty_sub)
 sub("\\)","\\)",ty_sub)
 gsub(ty_sub " *, *pointer *::",ty " , allocatable ::")
 gsub("=>NULL\\(\\)","")
 gsub(po,al)
 if (match($0,"nullify *\\( st al")) { 
  print "        if (allocated(" st al ")) deallocate(" st al ")"
  next; 
 }
 if (match($0,"allocate *\\(" st po)) {
  print "        if (allocated("st al")) deallocate(" st al ")"
 }

 gsub("associated *\\( *" st al,"allocated(" st al)
}
{print}
