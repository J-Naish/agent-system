# Schema Markup の例

よく使うスキーマタイプの完全な JSON-LD 例です。

## Organization

企業/ブランドのトップページや会社概要ページ向け。

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "サンプル株式会社",
  "url": "https://example.com",
  "logo": "https://example.com/logo.png",
  "sameAs": [
    "https://twitter.com/example",
    "https://linkedin.com/company/example",
    "https://facebook.com/example"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+1-555-555-5555",
    "contactType": "カスタマーサポート"
  }
}
```

---

## WebSite（SearchAction 付き）

トップページ向け。サイトリンク検索ボックスの対象になります。

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "サンプルサイト",
  "url": "https://example.com",
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://example.com/search?q={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  }
}
```

---

## Article / BlogPosting

ブログ記事やニュース記事向け。

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "スキーママークアップを実装する方法",
  "image": "https://example.com/image.jpg",
  "datePublished": "2024-01-15T08:00:00+00:00",
  "dateModified": "2024-01-20T10:00:00+00:00",
  "author": {
    "@type": "Person",
    "name": "山田 花子",
    "url": "https://example.com/authors/hanako"
  },
  "publisher": {
    "@type": "Organization",
    "name": "サンプル株式会社",
    "logo": {
      "@type": "ImageObject",
      "url": "https://example.com/logo.png"
    }
  },
  "description": "スキーママークアップ実装の完全ガイド...",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://example.com/schema-guide"
  }
}
```

---

## Product

商品ページ（EC または SaaS）向け。

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "プレミアムウィジェット",
  "image": "https://example.com/widget.jpg",
  "description": "プロ向けの人気ウィジェット",
  "sku": "WIDGET-001",
  "brand": {
    "@type": "Brand",
    "name": "サンプル社"
  },
  "offers": {
    "@type": "Offer",
    "url": "https://example.com/products/widget",
    "priceCurrency": "USD",
    "price": "99.99",
    "availability": "https://schema.org/InStock",
    "priceValidUntil": "2024-12-31"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "127"
  }
}
```

---

## SoftwareApplication

SaaS 商品ページやアプリのランディングページ向け。

```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "サンプルアプリ",
  "applicationCategory": "BusinessApplication",
  "operatingSystem": "Web, iOS, Android",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.6",
    "ratingCount": "1250"
  }
}
```

---

## FAQPage

よくある質問を含むページ向け。

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "スキーママークアップとは何ですか？",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "スキーママークアップは、検索エンジンがコンテンツを理解しやすくするための構造化データ語彙です..."
      }
    },
    {
      "@type": "Question",
      "name": "スキーマはどう実装すればよいですか？",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "推奨される方法は JSON-LD 形式を使い、ページの head 内に script を配置することです..."
      }
    }
  ]
}
```

---

## HowTo

手順解説コンテンツやチュートリアル向け。

```json
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "ウェブサイトにスキーママークアップを追加する方法",
  "description": "JSON-LD スキーマを実装する手順ガイド",
  "totalTime": "PT15M",
  "step": [
    {
      "@type": "HowToStep",
      "name": "スキーマタイプを選ぶ",
      "text": "ページ内容に合うスキーマタイプを特定します...",
      "url": "https://example.com/guide#step1"
    },
    {
      "@type": "HowToStep",
      "name": "JSON-LD を作成する",
      "text": "schema.org の仕様に従って JSON-LD マークアップを作成します...",
      "url": "https://example.com/guide#step2"
    },
    {
      "@type": "HowToStep",
      "name": "ページに追加する",
      "text": "ページの head セクションに script タグを挿入します...",
      "url": "https://example.com/guide#step3"
    }
  ]
}
```

---

## BreadcrumbList

パンくずナビゲーションがあるページ向け。

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "ホーム",
      "item": "https://example.com"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "ブログ",
      "item": "https://example.com/blog"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "SEOガイド",
      "item": "https://example.com/blog/seo-guide"
    }
  ]
}
```

---

## LocalBusiness

ローカルビジネスの拠点ページ向け。

```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "サンプルコーヒーショップ",
  "image": "https://example.com/shop.jpg",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "メインストリート123",
    "addressLocality": "サンフランシスコ",
    "addressRegion": "CA",
    "postalCode": "94102",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "37.7749",
    "longitude": "-122.4194"
  },
  "telephone": "+1-555-555-5555",
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "08:00",
      "closes": "18:00"
    }
  ],
  "priceRange": "$$"
}
```

---

## Event

イベントページ、ウェビナー、カンファレンス向け。

```json
{
  "@context": "https://schema.org",
  "@type": "Event",
  "name": "年次マーケティングカンファレンス",
  "startDate": "2024-06-15T09:00:00-07:00",
  "endDate": "2024-06-15T17:00:00-07:00",
  "eventAttendanceMode": "https://schema.org/OnlineEventAttendanceMode",
  "eventStatus": "https://schema.org/EventScheduled",
  "location": {
    "@type": "VirtualLocation",
    "url": "https://example.com/conference"
  },
  "image": "https://example.com/conference.jpg",
  "description": "年次マーケティングカンファレンスにぜひご参加ください...",
  "offers": {
    "@type": "Offer",
    "url": "https://example.com/conference/tickets",
    "price": "199",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "validFrom": "2024-01-01"
  },
  "performer": {
    "@type": "Organization",
    "name": "サンプル株式会社"
  },
  "organizer": {
    "@type": "Organization",
    "name": "サンプル株式会社",
    "url": "https://example.com"
  }
}
```

---

## 複数スキーマタイプ

@graph を使って複数スキーマを組み合わせます。

```json
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "サンプル株式会社",
      "url": "https://example.com"
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com",
      "name": "サンプルサイト",
      "publisher": {
        "@id": "https://example.com/#organization"
      }
    },
    {
      "@type": "BreadcrumbList",
      "itemListElement": [...]
    }
  ]
}
```

---
