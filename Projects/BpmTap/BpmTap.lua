
-- BpmTap
-- by luisfl.me

function _init() s=false a=1 b={} c=8 n=0 y=0 f=0 end
function _update60() 
	if s then f+=1 end if btnp(4) or btnp(5) then add(b,(60-f)*(60/(60-f))*(60/f)) f=0 s=true y=8 else y=0 end
	if #b>7 then a = #b-7 end for i=a,#b do n+=b[i] end bpm=mid(60,flr(n/8),240) n=0
end
function _draw() cls() if #b>3 then print(bpm,40,53,5) print(bpm,40,52,7) end sspr(0,y,24,8,40,60,48,16) end
