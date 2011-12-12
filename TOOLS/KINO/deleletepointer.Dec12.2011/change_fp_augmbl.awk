BEGIN{
 str=strftime("%b.%d.%Y");
 comment="ckino " str ": ";
}
/^ .*iv_p_ojcg/{
  print comment,$0
  if (match($0,"pointer")) { next;}
  if (match($0,"iv_p_ojcg *=> *slat%iv_p_ojcg")) { next;}
  gsub("iv_p_ojcg","slat%iv_p_ojcg")
  if (match($0,"slat%slat%")) {next;}
}
/^ .*iv_p_oidxcg/{
  print comment,$0
  if (match($0,"pointer")) { next;}
  if (match($0,"iv_p_oidxcg *=> *slat%iv_p_oidxcg")) { next;}
  gsub("iv_p_oidxcg","slat%iv_p_oidxcg")
  if (match($0,"slat%slat%")) {next;}
}
/^ .*rv_p_ocy/{
  print comment,$0
  if (match($0,"pointer")) { next;}
  if (match($0,"rv_p_ocy *=> *slat%rv_p_ocy")) { next;}
  gsub("rv_p_ocy","slat%rv_p_ocy")
  if (match($0,"slat%slat%")) {next;}
}
/^ .*rv_p_ocg/{
  print comment,$0
  if (match($0,"pointer")) { next;}
  if (match($0,"rv_p_ocg *=> *slat%rv_p_ocg")) { next;}
  gsub("rv_p_ocg","slat%rv_p_ocg")
  if (match($0,"slat%slat%")) {next;}
}
{print}
