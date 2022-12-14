    module bernul

    contains

    subroutine gorner(A,c,B)
    ! Процедура выполняет деление многочлена с коэффициентами из А на (x-c)
    ! и получает массив с коэфф. B, где последний элемент - остаток деления
    implicit none
    integer, parameter :: mp=4
    real(mp), dimension(0:), intent(in) :: A
    real(mp), intent(in) :: c ! с - уже известный корень
    real(mp), dimension(0:size(A)-1), intent(out) :: B
    integer :: n, i

    n=size(A)-1

    B(0)=A(0)
    do i=1,n
    ! Так как с - корень, то B(n) должен быть равен нулю
    B(i)=c*B(i-1)+A(i) 
    enddo

    end subroutine gorner

    subroutine bernulli(A0,X)
    ! Процедура возвращает массив корней X полинома,
    ! используя метод Бернулли, с коэффициентами из массива A
    implicit none
    integer, parameter :: mp=4
    real(mp), dimension(0:), intent(in) :: A0
    real(mp), dimension(0:(size(A0)-1)/2) :: A, B 
    real(mp), dimension(1:size(A0)-1), intent(out) :: X
    real(mp), dimension(1:size(A0)-1) :: Y
    real(mp) :: c 
    integer :: n, i
    !  A, B - массивы коэффициентов полиномов от t=x^2
    ! Y-массив из чисел, пределы которых ищутся в методе Бернулли
    ! c - корень многочлена

    n=size(A0)-1

    if (mod(n,2)>0) then
    ! Если степень нечетная, то полином Лежандра имеет нулевой корень
        X(n)=0.0
    endif

    ! Так как у полинома Лежандра все корни (кроме нуля) парные, 
    ! то после исключения из расмотрения нулевого корня 
    ! (т.е. понизили степень на 1) многочлен будет иметьвид 
    !  (x^2-c(1)^2)*...*(x^2-c(m)^2), где m=n/2, 
    ! n - степень мн-на после исключения нулевого корняБудем решать его     
    ! как многочлен степени n/2 от переменной t=x^2
 

    ! Это новый мн-н от переменной t=x^2 степени n/2 
    A(0:n/2)=A0(0:n:2) 
    i=0 

    do while (i<n/2-2)
    ! присваиваем случайные значения эл-там Y
        Y(1:n)=(/(sqrt(sin(i*5.0)*0.34+1.569-sqrt(0.01*i)),i=1,n)/) 
        ! Процедура найдет один корень мн-на степени n-i
        call koren(A(0:n/2-i),Y(1:n/2-i),c) 
        X(2*i+1)=sqrt(c); X(2*i+2)=-sqrt(c) ! - наиб. по модулю корень
        call gorner(A(0:n/2-i),c,B(0:n/2-i)) 
        A(0:n/2-i-1)=B(0:n/2-i-1)
        i=i+1 ! Здесь i получает номер деления, которое только что произошло
    enddo
 
    ! Эти строки - решение квадратного уравнения
    X(2*i+1)=sqrt((-A(1)+sqrt(A(1)**2-4*A(0)*A(2)))/2/A(0)); X(2*i+2)=-X(2*i+1) 
    X(2*i+3)=sqrt((-A(1)-sqrt(A(1)**2-4*A(0)*A(2)))/2/A(0)); X(2*i+4)=-X(2*i+3)  

    contains

    subroutine koren(A,Y,c)
    ! Процедура вычисляет наибольший по модулю корень многочлена
    implicit none
    integer, parameter :: mp=4
    real(mp), dimension(0:), intent(in) :: A
    real(mp) :: c ! c - искомый корень
    real(mp), dimension(1:size(A)) :: Y
    integer :: i, n
    real(mp) :: eps=0.1**mp*0.1

    n=size(A)-1

    do while (abs(Y(n)/Y(n-1)-Y(n-1)/Y(n-2)) > eps)
    ! p - и есть новый (следующий) член последовательности
        Y(n+1)=sum((A(1:n)/(-A(0)))*Y(n:1:-1)) 
        forall (i=1:n-1) Y(i)=Y(i+1)
        Y(n)=Y(n+1) ! Новый член последовательности
    enddo

    c=Y(n)/Y(n-1)

    end subroutine koren

    end subroutine bernulli

    end module bernul
