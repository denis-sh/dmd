
extern(C) int printf(const char*, ...);

/***************************************************/
// 6475

class Foo6475(Value)
{
    template T1(size_t n){ alias int T1; }
}

void test6475()
{
    alias Foo6475!(int) C1;
    alias C1.T1!0 X1;
    static assert(is(X1 == int));

    alias const(Foo6475!(int)) C2;
    alias C2.T1!0 X2;
    static assert(is(X2 == int));
}

/***************************************************/
// 7239

struct vec7239
{
    float x, y, z, w;
    alias x r;  //! for color access
    alias y g;  //! ditto
    alias z b;  //! ditto
    alias w a;  //! ditto
}

void test7239()
{
    vec7239 a = {x: 0, g: 0, b: 0, a: 1};
    assert(a.r == 0);
    assert(a.g == 0);
    assert(a.b == 0);
    assert(a.a == 1);
}

/***************************************************/
// 8123

void test8123()
{
    struct S { }

    struct AS
    {
        alias S Alias;
    }

    struct Wrapper
    {
        AS as;
    }

    Wrapper w;
    static assert(is(typeof(w.as).Alias == S));         // fail
    static assert(is(AS.Alias == S));                   // ok
    static assert(is(typeof(w.as) == AS));              // ok
    static assert(is(typeof(w.as).Alias == AS.Alias));  // fail
}

/***************************************************/
// 8147

enum A8147 { a, b, c }

@property ref T front8147(T)(T[] a)
if (!is(T[] == void[]))
{
    return a[0];
}

template ElementType8147(R)
{
    static if (is(typeof({ R r = void; return r.front8147; }()) T))
        alias T ElementType8147;
    else
        alias void ElementType8147;
}

void test8147()
{
    auto arr = [A8147.a];
    alias typeof(arr) R;
    auto e = ElementType8147!R.init;
}

/***************************************************/
// 8410

void test8410()
{
    struct Foo { int[15] x; string s; }

    Foo[5] a1 = Foo([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], "hello"); // OK
    Foo f = { s: "hello" }; // OK (not static)
    Foo[5] a2 = { s: "hello" }; // error
}

/***************************************************/
// 8942

alias const int A8942_0;
static assert(is(A8942_0 == const int)); // passes

void test8942()
{
    alias const int A8942_1;
    static assert(is(A8942_1 == const int)); // passes

    static struct S { int i; }
    foreach (Unused; typeof(S.tupleof))
    {
        alias const(int) A8942_2;
        static assert(is(A8942_2 == const int)); // also passes

        alias const int A8942_3;
        static assert(is(A8942_3 == const int)); // fails
        // Error: static assert  (is(int == const(int))) is false
    }
}

/***************************************************/

int main()
{
    test6475();
    test7239();
    test8123();
    test8147();
    test8410();
    test8942();

    printf("Success\n");
    return 0;
}
