ALTER TABLE  dbo.DimEmployee  ADD CONSTRAINT [PK_dbo.DimEmployee_EmployeeKey] PRIMARY KEY CLUSTERED ([EmployeeKey] ASC  )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]