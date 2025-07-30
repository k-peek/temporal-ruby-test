# 🎮 Bob's Game Store - Temporal Workflow Playground

A simple demo showcasing Temporal workflow patterns using Ruby on Rails. Features two workflow scenarios for selling Nintendo Switch 2 consoles.

## 🎯 Demo Scenarios

1. **Simple Purchase** - Basic sequential workflow: payment → confirmation email
2. **Payment Retry with Fallbacks** - Error handling: Credit Card → Backup Card → Buy Now Pay Later
3. **Pre-order with Release Date** - Long-running workflows with timers and scheduling

## 🚀 Quick Start

### Prerequisites

-  Easiest way to run is through devbox: curl -fsSL https://get.jetify.com/devbox | bash

### Running the Demo

1. **Clone and enter the project**:
   ```bash
   git clone <your-repo-url>
   cd temporal_playground
   ```

2. **Start all services with one command**:
   ```bash
   devbox shell
   ```
   
   This automatically starts:
   - Temporal server (localhost:8233)
   - Rails Temporal worker
   - Rails web server (localhost:3001)

3. **Open the demo**:
   ```
   http://localhost:3001
   ```

4. **Try the workflows**:
   - Use the carousel interface to navigate between demos
   - Click "Try [Demo Name]" buttons to start workflows
   - Monitor progress in the Temporal UI at http://localhost:8233

## 🏗 Project Structure

```
app/
├── controllers/
│   └── bobs_game_store_controller.rb    # Demo endpoints
├── workflows/
│   ├── simple_purchase_workflow.rb      # Basic sequential workflow
│   ├── payment_retry_workflow.rb        # Error handling & fallbacks
│   └── preorder_workflow.rb            # Long-running with timers
├── activities/
│   ├── process_payment_activity.rb      # Payment processing
│   ├── *_payment_activity.rb           # Different payment methods
│   ├── send_*_email_activity.rb        # Email notifications
│   └── *_inventory_activity.rb         # Inventory management
└── views/
    └── bobs_game_store/                 # HTML interface with carousel
```


## 🛠 Development

### Key Patterns

- **Workflows**: Extend `Temporalio::Workflow::Definition`
- **Activities**: Extend `Temporalio::Activity::Definition`
- **Time Handling**: Use `Temporalio::Workflow.now` (never `Time.current`)
- **No Side Effects**: Workflows must be deterministic

### Temporal Compatibility

This project avoids common Temporal pitfalls:
- ✅ No `puts` or file I/O in workflows
- ✅ No `Time.current` or `Time.parse` in workflows  
- ✅ Bootsnap disabled (conflicts with workflow execution)
- ✅ Deterministic execution patterns

## 📝 Log Files

When running with devbox, logs are saved to:
- `temporal-server.log` - Temporal server output
- `temporal-worker.log` - Rails worker output  
- `rails-server.log` - Rails server output

## 📚 Learn More

- [Temporal Documentation](https://docs.temporal.io/)
- [Temporal Ruby SDK](https://github.com/temporalio/sdk-ruby)

---

🎮 **Happy workflow building!** Start with the simple purchase, then explore payment retries and long-running pre-orders to see Temporal's full power.