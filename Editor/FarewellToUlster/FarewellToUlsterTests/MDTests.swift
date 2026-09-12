//
//  MDTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 12/09/2026.
//

import Testing
@testable import FarewellToUlster

struct MDTests {

    @Test func testAnchor() async throws {
        #expect(MDAnchor().markdown == "<a href=\"/Farewell-to-Ulster/\"></a>")
        #expect(MDAnchor(content: "Title").markdown == "<a href=\"/Farewell-to-Ulster/\">Title</a>")
        #expect(MDAnchor(number: "1234", content: "Title").markdown == "<a href=\"/Farewell-to-Ulster/1234.html\">Title</a>")
        #expect(MDAnchor(type: .era, number: "1234", content: "Title").markdown == "<a href=\"/Farewell-to-Ulster/Eras/1234.html\">Title</a>")
        #expect(MDAnchor(type: .poem, number: "1234", content: "Title").markdown == "<a href=\"/Farewell-to-Ulster/Poems/1234.html\">Title</a>")
    }

    @Test func testBreadcrumb() async throws {
        #expect(MDBreadcrumb().markdown == """
<nav class="breadcrumb">
<a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
<a href="/Farewell-to-Ulster/"></a>
</nav>
""")
        #expect(MDBreadcrumb(eraInfo: MDInfo(title: "Now", number: "1234")).markdown == """
<nav class="breadcrumb">
<a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
<a href="/Farewell-to-Ulster/Eras/1234.html">Now</a>
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
    
    @Test func testElement() async throws {
        #expect(MDElement(name: "XYZ", attributes: ["a": "A", "b": "B", "c": "C"], content: "Gobbledegook").markdown == """
<XYZ a="A" b="B" c="C">Gobbledegook</XYZ>
""")
        #expect(MDElement(name: "XYZ", attributes: ["a": "A", "b": "B", "c": "C"], content: "Gobbledegook", isMultiline: true).markdown == """
<XYZ a="A" b="B" c="C">
Gobbledegook
</XYZ>
""")
    }
    
    @Test func testPoem() async throws {
        let poem = MDPoem(eraInfo: MDInfo(title: "Sometime", number: "0001"),
                          info: MDInfo(title: "Talking", number: "0002"),
                          text: "Hello world",
                          previousNumber: "0001",
                          previousTitle: "Previous One",
                          nextNumber: "0003",
                          nextTitle: "Next One")
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

    @Test func testEra() async throws {
        let info = MDInfo(title: "Sometime", number: "0001")
        let poem = MDPoem(eraInfo: info,
                          info: MDInfo(title: "Talking", number: "0002"),
                          text: "Hello world",
                          previousNumber: "0001",
                          previousTitle: "Previous One",
                          nextNumber: "0003",
                          nextTitle: "Next One")
        let era = MDEra(info: info, text: "Sometime is now", poems: [poem])
        print(era.markdown)
        #expect(era.markdown == """
---
layout: era
title: Sometime
---
<nav class="breadcrumb">
<a href="/Farewell-to-Ulster/">Farewell to Ulster</a> /
<a href="/Farewell-to-Ulster/"></a>
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
