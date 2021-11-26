#passo1 - identificar novos padrões dos arquivos raw
resource "aws_glue_trigger" "crawler_raw_produtcs" {
  name          = "crawler_raw_produtos_trigger"
  type          = "ON_DEMAND"
  enabled       = false
  workflow_name = aws_glue_workflow.etl_produtos.name

  actions {
    crawler_name = aws_glue_crawler.raw_s3.name
  }

  depends_on = [
    aws_glue_trigger.job_produtos
  ]
}

#passo2 - executar job e tabular arquivo (parquet)
resource "aws_glue_trigger" "job_produtos" {
  name          = "job_produtos_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.etl_produtos.name

  actions {
    job_name = aws_glue_job.extract_mainframe_data.name
  }

  predicate {
    conditions {
      crawler_name = aws_glue_crawler.raw_s3.name
      crawl_state  = "SUCCEEDED"
    }
  }

  depends_on = [
    aws_glue_trigger.crawler_processed_products
  ]
}

#passo3 - identificar novos padrões nos arquivos processed
resource "aws_glue_trigger" "crawler_processed_products" {
  name          = "crawler_processed_produtos_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.etl_produtos.name

  actions {
    crawler_name = aws_glue_crawler.processed_s3.name
  }

  predicate {
    conditions {
      job_name = aws_glue_job.extract_mainframe_data.name
      state    = "SUCCEEDED"
    }
  }
}
