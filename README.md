Shopify & Google Search Orchestrator
This project is a high-performance .NET Core solution designed to bridge the gap between global market data and e-commerce management. It enables automated Google product searching and seamless synchronization with the Shopify Admin API.

🚀 Key Modules
1. Shopify Integration
Automated Price Sync: Synchronize product prices and inventory levels with Shopify stores.

Variant Management: Deep integration with Shopify product variants for precise updates.

Batch Processing: Handles large volume updates while respecting Shopify API rate limits.

2. Google Product Search & Monitoring
Automated Product Discovery: Scans and tracks product data from Google search results.

Price Analysis: Compare local or competitor prices with live market data.

Search History (Arama Geçmişi): Persistent logging of search queries and results for trend analysis.

3. Background Services
OtoTakip (Auto-Track): Background workers (using .NET BackgroundService) that periodically execute search and sync tasks.

DailySearchWorker: A specialized worker for daily automated market scans.

🛠 Tech Stack
Backend: .NET 8 / ASP.NET Core

Frontend: Blazor Server (Interactive Dashboard)

ORM: Entity Framework Core (MySQL)

API & Scraping: Shopify REST/GraphQL API & Custom Search Integration

Architecture: N-Tier / Clean Architecture

🏗 Project Structure
IbelCode.Core: Domain models, Entities (Products, SearchResults), and Abstractions.

IbelCode.Data: DBContext and Repository implementations for MySQL.

IbelCode.Service: Business logic for Shopify API communication and Google Search algorithms.

IbelCode.Web: The Blazor UI for monitoring sync status and manual search triggers.

⚙️ Setup
Clone & Configure:
Rename appsettings.Example.json to appsettings.json.

API Keys:
Provide your Shopify API Key and Search API/Scraper credentials in the config file.

Database:

Bash
dotnet ef database update
Launch:

Bash
dotnet run

🛡 Disclaimer & Security
Portfolio Version: Advanced scraping algorithms and commercial-grade Shopify logic are simplified for demonstration purposes.

License: This project is licensed under the GPL-3.0 License.
Let's build something great together:

Company: ibelcode

Lead Developer: Ibrahim Erkan

LinkedIn: https://www.linkedin.com/in/ibrahim-erkann/

Email: ibrahim@erkanyazilim.com



