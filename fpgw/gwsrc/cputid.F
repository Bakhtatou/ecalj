c Time routines -------------------------------------------------------------
c This dummy time routine
#ifdef ETIME_DUMMY
      real*4 function etime(ar)
      real*4 ar(2)
      ar = 0.0
      end
#endif
c
c       subroutine fdate(s)
c       character(*) s
c       s = ' '
c       end
c----------------------------------------------------------------------------





c----------------------------------------------------------------------
      double precision function cpumin(ifile,cpu0)
      implicit real*8(a-h,o-z)

c cpu time in minutes for RISC: mclock()/600.d0
c cpusek is the total cputime - cpu0

c     cpumin   = mclock()/600.d0 - cpu0
      cpusec   = (secnds(0.0) - cpu0)
      cpumin   = cpusec/60.d0
c     cpusec=0d0
c     cpumin=0d0
c----
      if(ifile .le. 0)then
        write(*,6400)cpusec,cpumin
      else
        write(ifile,6400)cpusec,cpumin
      end if
 6400 format(/' cpu time = ',f15.4,' secs ',f15.4,' mins ')

      return
      end
c----------------------------------------------------------------------
c     double precision function cpusec(cpu0)
c     implicit real*8(a-h,o-z)
c
c cpu time in seconds for RISC
c cpusek is the total cputime - cpu0
c
c     cpusec   = mclock()/100.d0 - cpu0
c     return
c     end
c----------------------------------------------------------------------
      subroutine cputid(ifile)
      implicit real*8(a-h,o-z)
c cpu time in seconds and minutes for RISC IBM: mclock()/100 (secs)
c                     for HP: secnds(0.0)
c                        DEC: etime(etw)
c ifile = file number where the cpu time information is
c         to be printed
c ifile = 0 ==> screen
      real*4 cpuetime, etw(2),cpulast, etime
      data cpu0 /-1.d0/
      save cpu0
      character*(*):: message
      if(ifile .lt. 0)stop 'cputid: negative unit number'
      cpuetime = etime(etw)
      if (cpu0 .lt. 0.d0) cpu0 = cpuetime
      cpusec   = cpuetime - cpu0
      cpumin   = cpusec/60.d0
      if(ifile .eq. 0)then
        write(*,6400)cpusec,cpumin
      else
        write(ifile,6400)cpusec,cpumin
      end if
 6400 format(' CPU= ',f12.4,' secs',f7.1,' mins')
      return
!!
      entry cputid2(message,ifile)
      if(ifile .lt. 0)stop 'cputid: negative unit number'
      cpuetime = etime(etw)
      if (cpu0 .lt. 0.d0) cpu0 = cpuetime
      cpusec   = cpuetime - cpu0
      cpumin   = cpusec/60.d0
      if(ifile .eq. 0)then
        write(*,6401)trim(message),cpusec,cpumin
      else
        write(ifile,6401)trim(message),cpusec,cpumin
      end if
 6401 format(a,' CPU= ',f12.4,' secs',f7.1,' mins')
      return
      end



      module m_realtimediff
      implicit none
      integer,parameter:: nmax=10000
      integer:: i1(nmax)=nmax*0 
      character(30):: msg(nmax)
      real(8):: elapse(nmax)=nmax*0.0d0
      real(8):: start(nmax)=nmax*0.0d0
      end module m_realtimediff


      subroutine realtimediff(id,msg0)
      use m_realtimediff 
      integer,intent(in):: id
      character(*),intent(in)::msg0

      integer::mode
      real(8):: diff
      integer:: i2,imax
#define USEMPIWTIME 
#ifdef USEMPIWTIME
      real(8):: mpi_wtime

      mode=0
      if (len_trim(msg0)>0) mode=1 

      if (mode.eq.0) then
        i1(id)=i1(id)+1
        start(id)=mpi_wtime()
      else
        diff=mpi_wtime()
        msg(id)=msg0
        elapse(id)=elapse(id)+diff-start(id)
      endif
#else
      if (mode.eq.0) then 
        call system_clock(i1(id))
      else
        msg(id)=msg0
        call system_clock(i2,irate,imax)
        diff = i2-i1(id)
        if (i1(id)>i2) diff=imax-i1(id)+i2
        diff= dble(i2-i1(id))/dble(irate)  ! real time
       ! write(*,*)'mpi=',str_rank,trim(msg),diff
        elapse(id)=elapse(id)+diff  
      endif 
#endif

      end subroutine realtimediff

      subroutine print_realtimediff()
      use m_mpi
      use m_realtimediff
      integer:: i,j,isize
      character(30):: str

      call flush()
      call mpi__barrier()

      isize=0
      if ( mpi__rank.eq.0 ) then 
         do i=1,nmax
           if (i1(i).ne.0 ) then 
           str=msg(i)
           do j=1,30
             if (str(j:j).eq.' ') str(j:j)='_'
           enddo
           write(*,'(a,i3,1x,i4,1x,a,1x,F10.2,1x,i5)')'mpi=',mpi__rank,i,trim(str),elapse(i) ,i1(i)
           endif 
         enddo
      endif

      do isize=1,mpi__size-1
          if (mpi__rank.eq.isize) then 
                 call mpi__send(i1,0)
                 call mpi__send(elapse,0)
          else if (mpi__rank.eq.0) then 
                 call mpi__recv(i1,isize)
                 call mpi__recv(elapse,isize)
           do i=1,nmax
           if (i1(i).ne.0 ) then
           str=msg(i)
           do j=1,30
             if (str(j:j).eq.' ') str(j:j)='_'
           enddo
           write(*,'(a,i3,1x,i4,1x,a,1x,F10.2,1x,i5)')'mpi=',isize,i,trim(str),elapse(i) ,i1(i)
           endif
           enddo 
         endif 
      enddo
      call flush()
      call mpi__barrier()
      end subroutine print_realtimediff

