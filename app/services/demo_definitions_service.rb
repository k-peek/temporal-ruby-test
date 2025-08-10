class DemoDefinitionsService
  def self.all
    demos = [
      {
        name: "Simple Purchase",
        description: "Basic payment → confirmation email workflow",
        path: "/kevins_store/simple_purchase",
        features: [ "Sequential activities", "Basic workflow patterns" ],
        mermaid: %(
          flowchart TD
            A((Start Purchase)) --> B[Process Payment]
            B --> C[Send Confirmation Email]
            C --> D((End))

            style A fill:#4fc3f7,stroke:#01579b,stroke-width:3px,color:#000
            style B fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style C fill:#ba68c8,stroke:#4a148c,stroke-width:2px,color:#000
            style D fill:#81c784,stroke:#2e7d32,stroke-width:3px,color:#000
        ),
        code_files: nil
      },
      {
        name: "Order Cancellation with Compensation",
        description: "Complete purchase → Customer cancels → Refund & restock inventory",
        path: "/kevins_store/order_cancellation",
        features: [ "Compensating actions", "Saga pattern", "Rollback operations" ],
        mermaid: %(
          flowchart TD
            A((Start Purchase)) --> B[Process Payment]
            B --> C[Reserve Inventory]
            C --> D[Send Confirmation Email]
            D --> E{Wait for Cancellation Window}
            E -->|No Cancellation| F[Ship Order]
            E -->|Customer Cancels| G[Process Refund]
            G --> H[Restock Inventory]
            H --> I[Send Cancellation Email]
            F --> J((Order Shipped))
            I --> K((Order Cancelled))

            style A fill:#4fc3f7,stroke:#01579b,stroke-width:3px,color:#000
            style B fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style C fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style D fill:#ba68c8,stroke:#4a148c,stroke-width:2px,color:#000
            style E fill:#f06292,stroke:#ad1457,stroke-width:2px,color:#000
            style F fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style G fill:#ef5350,stroke:#c62828,stroke-width:2px,color:#fff
            style H fill:#ef5350,stroke:#c62828,stroke-width:2px,color:#fff
            style I fill:#ba68c8,stroke:#4a148c,stroke-width:2px,color:#000
            style J fill:#81c784,stroke:#2e7d32,stroke-width:3px,color:#000
            style K fill:#ffab91,stroke:#bf360c,stroke-width:3px,color:#000
        ),
        code_files: nil
      }
    ]

    # Populate code_files after array creation to avoid autoloading issues
    demos[0][:code_files] = CodeFilesService.for_demo("simple_purchase")
    demos[1][:code_files] = CodeFilesService.for_demo("order_cancellation")

    demos
  end
end
