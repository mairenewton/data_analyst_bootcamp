view: user_facts {
    derived_table: {
      sql: select users.id,
               users.state,
               count(distinct order_items.order_id) lifetime_orders,
               sum(order_items.sale_price) as lifetime_revenue
          from users
          left join order_items
                on users.id = order_items.user_id

        group by 1, 2
         ;;
    }

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }

    dimension: state {
      type: string
      sql: ${TABLE}.state ;;
    }

    dimension: lifetime_orders {
      type: number
      sql: ${TABLE}.lifetime_orders ;;
    }

    dimension: lifetime_revenue {
      type: number
      sql: ${TABLE}.lifetime_revenue ;;
    }

    measure: avg_lifetime_orders {
      type: average
      sql: ${lifetime_orders} ;;
    }

    measure: avg_lifetime_revenue {
      type: average
      sql:  ${lifetime_revenue} ;;
    }

    set: detail {
      fields: [id, state, lifetime_orders, lifetime_revenue]
    }
  }
