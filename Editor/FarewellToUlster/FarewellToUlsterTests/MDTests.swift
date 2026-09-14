//
//  MDTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 12/09/2026.
//

import Testing
@testable import FarewellToUlster

struct MDTests {

    @Test func testA() async throws {
        #expect(a() == """
        <a href=""></a>
        """)
        #expect(a(info: .site) == """
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a>
        """)
        #expect(a(info: .poem(title: "It's Me!", number: "1234")) == """
        <a href="/Farewell-to-Ulster/Poems/1234.html">It's Me!</a>
        """)
        #expect(a(info: .poem(title: "Why Not?", number: "2345"), classValue: "poo") == """
        <a class="poo" href="/Farewell-to-Ulster/Poems/2345.html">Why Not?</a>
        """)
        #expect(a(info: .era(title: "Hey", number: "3456")) == """
        <a href="/Farewell-to-Ulster/Eras/3456.html">Hey</a>
        """)
        #expect(a(info: .era(title: "Hey What?", number: "4567"), classValue: "pop") == """
        <a class="pop" href="/Farewell-to-Ulster/Eras/4567.html">Hey What?</a>
        """)
    }
    
    @Test func testBreadcrumb() async throws {
        #expect(MDBreadcrumb(info: .none).markdown == """
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href=""></a>
        </nav>
        """)
        #expect(MDBreadcrumb(info: .era(title: "Now", number: "1234")).markdown == """
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href="/Farewell-to-Ulster/Eras/1234.html">Now</a>
        </nav>
        """)
        #expect(MDBreadcrumb(info: .poem(title: "Now", number: "1234")).markdown == """
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href=""></a>
        </nav>
        """)
    }
    
    @Test func testHeading() async throws {
        #expect(MDHeading(title: "Title").markdown == """
        <header class="post-header">
        <h1 class="post-title">Title</h1>
        </header>
        """)
    }
    
    @Test func testMiddlePoem() async throws {
        let poem = MDPoem(eraInfo: .era(title: "Sometime", number: "0001"),
                          info: .poem(title: "Talking", number: "0002"),
                          previousInfo: .poem(title: "Previous One", number: "0001"),
                          nextInfo: .poem(title: "Next One", number: "0003"),
                          text: "Hello world")
        #expect(poem.markdown == """
        ---
        layout: poem
        title: Talking
        ---
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href="/Farewell-to-Ulster/Eras/0001.html">Sometime</a>
        </nav>

        <header class="post-header">
        <h1 class="post-title">Talking</h1>
        </header>

        Hello world

        <nav class="prev-next">
        <a class="prev" href="/Farewell-to-Ulster/Poems/0001.html">← Previous One</a>
        <a class="next" href="/Farewell-to-Ulster/Poems/0003.html">Next One →</a>
        </nav>
        """)
    }

    @Test func testFirstPoem() async throws {
        let poem = MDPoem(eraInfo: .era(title: "Sometime", number: "0001"),
                          info: .poem(title: "Talking", number: "0002"),
                          previousInfo: .none,
                          nextInfo: .poem(title: "Next One", number: "0003"),
                          text: "Hello world")
        print(poem.markdown)
        #expect(poem.markdown == """
        ---
        layout: poem
        title: Talking
        ---
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href="/Farewell-to-Ulster/Eras/0001.html">Sometime</a>
        </nav>

        <header class="post-header">
        <h1 class="post-title">Talking</h1>
        </header>

        Hello world

        <nav class="prev-next">
        <span></span>
        <a class="next" href="/Farewell-to-Ulster/Poems/0003.html">Next One →</a>
        </nav>
        """)
    }

    @Test func testLastPoem() async throws {
        let poem = MDPoem(eraInfo: .era(title: "Sometime", number: "0001"),
                          info: .poem(title: "Talking", number: "0002"),
                          previousInfo: .poem(title: "Previous One", number: "0001"),
                          nextInfo: .none,
                          text: "Hello world")
        #expect(poem.markdown == """
        ---
        layout: poem
        title: Talking
        ---
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href="/Farewell-to-Ulster/Eras/0001.html">Sometime</a>
        </nav>

        <header class="post-header">
        <h1 class="post-title">Talking</h1>
        </header>

        Hello world

        <nav class="prev-next">
        <a class="prev" href="/Farewell-to-Ulster/Poems/0001.html">← Previous One</a>
        <span></span>
        </nav>
        """)
    }

    @Test func testOnlyPoem() async throws {
        let poem = MDPoem(eraInfo: .era(title: "Sometime", number: "0001"),
                          info: .poem(title: "Talking", number: "0002"),
                          previousInfo: .none,
                          nextInfo: .none,
                          text: "Hello world")
        #expect(poem.markdown == """
        ---
        layout: poem
        title: Talking
        ---
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href="/Farewell-to-Ulster/Eras/0001.html">Sometime</a>
        </nav>

        <header class="post-header">
        <h1 class="post-title">Talking</h1>
        </header>

        Hello world

        <nav class="prev-next">
        <span></span>
        <span></span>
        </nav>
        """)
    }


    @Test func testEra() async throws {
        let eraInfo: MDInfo = .era(title: "Sometime", number: "0001")
        let poem = MDPoem(eraInfo: eraInfo,
                          info: .poem(title: "Talking", number: "0002"),
                          previousInfo: .poem(title: "Previous One", number: "0001"),
                          nextInfo: .poem(title: "Next One", number: "0003"),
                          text: "Hello world")
        let era = MDEra(info: eraInfo, text: "Sometime is now", poems: [poem])
        #expect(era.markdown == """
        ---
        layout: era
        title: Sometime
        ---
        <nav class="breadcrumb">
        <a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
        <a href=""></a>
        </nav>

        <header class="post-header">
        <h1 class="post-title">Sometime</h1>
        </header>

        Sometime is now

        <ul>
        <li><a href="/Farewell-to-Ulster/Poems/0002.html">Talking</a></li>
        </ul>
        """)
    }
}
