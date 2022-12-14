module newtonmethod
        use lead
        use func

        contains

        subroutine newton(X0,nummax,X,F)
        ! Процедура контролирует получение вектора решения на каком-то шаге итераций
        implicit none
        real, dimension(1:), intent(in) :: X0 ! X0 - начальное приближение
        real, dimension(1:size(X0)), intent(out) :: X
        real, dimension(1:size(X0)) :: Xnew ! Xnew - вектор X, получаемый при новом шаге итераций
        real :: eps=1.0e-4
        integer, intent(in) :: nummax
        integer :: i, n
        interface
        function F(X)
        real, dimension(1:), intent(in) :: X
        real, dimension(1:size(X)) :: F
        end function F
        end interface

        n=size(X0)

        X=X0
	i=nummax
	Xnew=X0+1.0
        do while (sum(abs(X-Xnew))>eps .and. i>=1)
            X=Xnew

            call solve(X,Xnew,F)
            i=i-1
        enddo
        X=Xnew 

        end subroutine newton


        subroutine solve(X,Xnew,F)
        ! Процедура получает новый вектор решений по методу Ньютона (с помощью итераций)
        implicit none
        real, dimension(1:), intent(in) :: X
        real, dimension(1:size(X)), intent(out) :: Xnew
        real, dimension(1:size(X),1:size(X)) :: df ! df - матрица Якоби функции f
        real, dimension(1:size(X)+1,1:size(X)) :: M ! M - расширенная матрица системы f+sum(df*(Xnewk-Xk))=0
        integer :: i, n
        interface
        function F(X) 
        real, dimension(1:), intent(in) :: X
        real, dimension(1:size(X)) :: F
        end function F
        end interface

        n=size(X)
     
        call yakobmatrix(X,df,F)
        M(n+1,1:n)=-F(X)
        M(1:n,1:n)=df(1:n,1:n)

        call leadfun(M,Xnew,n)
        Xnew=Xnew+X 

        end subroutine solve


        subroutine yakobmatrix(X0,df,F)
        ! *** Процедура создает матрицу Якоби для f(x) в точке X0
        implicit none
        real, dimension(1:), intent(in) :: X0
        real, dimension(1:size(X0),1:size(X0)), intent(out) :: df
        real, dimension(1:size(X0)) :: X
        real :: eps=1e-3
        integer :: i, n
        interface
        function F(X)
        real, dimension(1:), intent(in) :: X
        real, dimension(1:size(X)) :: F
        end function F
        end interface

        n=size(X0)

        do i=1,n
            X=X0
            X(i)=X0(i)+eps
            df(i,1:n)=(F(X)-F(X0))/eps
        enddo

        end subroutine yakobmatrix

        end module newtonmethod
