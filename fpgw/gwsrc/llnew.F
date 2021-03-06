#ifdef COMMONLL
      blockdata llset
      dimension ll(51**2)
      data ll/
     &       0,  3* 1,  5* 2,  7* 3,  9* 4, 11* 5, 13* 6, 15* 7, 17* 8, 19* 9,
     &   21*10, 23*11, 25*12, 27*13 ,29*14 ,31*15 ,33*16, 35*17, 37*18, 39*19,
     &   41*20, 43*21, 45*22, 47*23 ,49*24 ,51*25 ,53*26, 55*27, 57*28, 59*29,
     &   61*30, 63*31, 65*32, 67*33 ,69*34 ,71*35 ,73*36, 75*37, 77*38, 79*39,
     &   81*40, 83*41, 85*42, 87*43 ,89*44 ,91*45 ,93*46, 95*47, 97*48, 99*49, 101*50/
      common/llblock/ll
      end blockdata
#else
      integer(4) function ll(ilm)
      integer(4),parameter :: lmx=50
      integer(4),save:: lla((lmx+1)**2)
      logical:: init=.true.
      if(ilm>(lmx+1)**2) stop 'll: ilm too large'
      if(init) then
        do l=0,lmx
          lini= l**2 + 1
          lend=(l+1)**2
          lla(lini:lend)=l
        enddo
      endif
      ll = lla(ilm)
ccccccccccccccccccccccc
c      do i=1,(lmx+1)**2
c        write(117,"(' i ll=',2i5)")i,lla(i)
c      enddo
c      stop 'test end'
cccccccccccccccccccccccc
      return
      end
#endif
